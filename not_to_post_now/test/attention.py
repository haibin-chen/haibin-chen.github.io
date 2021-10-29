def multihead_attention(queries, keys, values, last_layer=False):
    # keys, values: same shape of [N, T_k, C_k]
    # queries: A 3d Variable with shape of [N, T_q, C_q]
    # Linear projections
    Q = self.Q_proj(queries)  # (N, T_q, C)
    K = self.K_proj(keys)  # (N, T_q, C)
    V = self.V_proj(values)  # (N, T_q, C)
    # Split and concat
    Q_ = torch.cat(torch.chunk(Q, self.num_heads, dim=2), dim=0)  # (N*head, times1, d)
    K_ = torch.cat(torch.chunk(K, self.num_heads, dim=2), dim=0)  # (N*head, times2, d)
    V_ = torch.cat(torch.chunk(V, self.num_heads, dim=2), dim=0)  # (N*head, times2, d)
    # Multiplication
    outputs = torch.bmm(Q_, K_.permute(0, 2, 1))
    # Scale (N*head, time1, time2)
    outputs = outputs / (K_.size()[-1] ** 0.5)
    
    # Query Masking
    # mask (N, 1, time1, time2)
    outputs = outputs.masked_fill(mask, min_value)
    outputs = F.softmax(outputs, dim=-1).masked_fill(mask, 0)
    # Dropouts
    outputs = self.attention_dropout(outputs)  # (N*head, time1, time2)
    if last_layer == True:
        return outputs
    # Weighted sum
    outputs = torch.bmm(outputs, V_)  # (N*head, time1, d)
    # Restore shape
    outputs = torch.cat(torch.chunk(outputs, self.num_heads, dim=0), dim=2)  # (N, time1, d*head)
    # Residual connection
    outputs = FFN(outputs)+queries
    
    return outputs
