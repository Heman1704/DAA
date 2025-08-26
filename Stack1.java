import java.util.*;

class Stack<T> {
    private List<T> stack;
    private int maxSize;

    public Stack(int size) {
        stack = new ArrayList<>();
        maxSize = size;
    }

    public boolean isEmpty() {
        return stack.isEmpty();
    }

    public boolean isFull() {
        return stack.size() == maxSize;
    }

    public T peek() {
        if (!isEmpty()) {
            return stack.get(stack.size() - 1);
        }
        return null;
    }

    public void push(T element) {
        if (!isFull()) {
            stack.add(element);
        } else {
            System.out.println("Stack is full");
        }
    }

    public T pop() {
        if (!isEmpty()) {
            return stack.remove(stack.size() - 1);
        }
        return null;
    }
}

public class Stack1 {
    public static void main(String[] args) {
        Stack<Integer> stack = new Stack<>(5);

        stack.push(10);
        stack.push(20);
        stack.push(30);

        System.out.println("Top element: " + stack.peek());
        System.out.println("Popped element: " + stack.pop());

        System.out.println("Top element after pop: " + stack.peek());
    }
}

