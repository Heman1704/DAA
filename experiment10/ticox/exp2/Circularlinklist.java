public class Circularlinklist {
    class Node {
        int data;
        Node next;
        public Node(int val) {
            this.data = val;
            this.next = null;
        }
    }

    Node head, tail;

    void insertifempty(int val) {
        Node newnode = new Node(val);
        head = newnode;
        tail = newnode;
        newnode.next = head; 
    }

    void append(int val) {
        Node newnode = new Node(val);
        tail.next = newnode;
        newnode.next = head;
        tail = newnode;
    }

    void delete() {
        if (head == null) return; 
        head = head.next;
        tail.next = head; 
    }

    void delete(int val) {
        if (head == null) return;
        Node curr = head;
        if (curr.data == val) {
            head = head.next;
            tail.next = head;
            return;
        }
        while (curr.next != head) {
            if (curr.next.data == val) {
                curr.next = curr.next.next; 
                if (curr.next == head) {
                    tail = curr;
                }
                return;
            }
            curr = curr.next;
        }
    }

    public static void main(String[] args) {
        Circularlinklist ob = new Circularlinklist();
        if (ob.head == null) {
            ob.insertifempty(0); 
        }
        ob.append(1);
        ob.append(2);
        ob.append(8);
        ob.delete(2);
        ob.tail = ob.head;
        while (true) {
            System.out.println(ob.tail.data);
            ob.tail = ob.tail.next;
            if (ob.tail == ob.head) {
                break;
            }
        }
    }
}
