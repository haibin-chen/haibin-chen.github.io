import math
import numpy as np

# BP with XOR operation

class MLP:
    def __init__(self, train_data, target, alpha, epochs, num_input=2, num_hidden=2, num_output=1):
        self.train_data = train_data
        self.target = target
        self.alpha = alpha
        self.epochs = epochs
        self.weights_01 = np.random.uniform(size=(num_input, num_hidden))
        self.weights_12 = np.random.uniform(size=(num_hidden, num_output))
        self.bias_01 = np.random.uniform(size=(1, num_hidden))
        self.bias_12 = np.random.uniform(size=(1, num_output))
        self.losses = []
        self.acc = []

    def _sigmoid(self, x):
        return 1.0 / (1.0+np.exp(-x))

    def _dersigmoid(self, x):
        return x * (1-x)

    def forward(self, batch):
        self.hidden_ = np.dot(batch, self.weights_01) + self.bias_01
        self.hidden_out = self._sigmoid(self.hidden_)
        self.output_ = np.dot(self.hidden_out, self.weights_12) + self.bias_12
        self.output_final = self._sigmoid(self.output_)

    def back_propagate(self):
        # MSE
        loss = (self.target - self.output_final) ** 2
        self.losses.append(np.mean(loss))

        error_term = (self.target - self.output_final) #delta
        grad01 = np.dot(self.train_data.T, (error_term*self._dersigmoid(self.output_final)*self.weights_12.T)*self._dersigmoid(self.hidden_out))
        grad12 = np.dot(self.hidden_out.T, error_term*self._dersigmoid(self.output_final))

        self.weights_01 += self.alpha * grad01
        self.weights_12 += self.alpha * grad12

        grad01_bias = (error_term*self._dersigmoid(self.output_final)*self.weights_12.T)*self._dersigmoid(self.hidden_out)

        self.bias_01 += np.sum(self.alpha*grad01_bias, axis=0)

        grad12_bias = error_term*self._dersigmoid(self.output_final)

        self.bias_12 += np.sum(self.alpha*grad12_bias, axis=0)

    def train(self):
        for _ in range(self.epochs):
            self.forward(self.train_data)
            self.back_propagate()

    def test(self):
        correct = 0
        for o in range(len(self.target)):
            if math.isclose(self.forward(self.train_data)[o], self.target[o], abs_tol=0.5):
                correct += 1
        print("test acc:", "%.2f%%"%(correct/len(self.output_final))*100)

if __name__ = '__main__':
    train_data = np.array([[0,0],[0,1],[1,0],[1,1]])
    target_data = np.array([[0],[1],[1],[0]])

    model = MLP(train_data, target_data, 0.1, 10000)
    model.train()
    model.test()
