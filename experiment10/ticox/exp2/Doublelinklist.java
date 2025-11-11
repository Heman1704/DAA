public class Doublelinklist {
    private class Node{
        int data;
        Node next;
        Node prev;

        public Node(int val){
            this.data=val;
            this.next=null;
            this.prev=null;
        }
    }Node head;
    public void insert(int val){
        Node newnode=new Node(val);
        newnode.next=head;
        newnode.prev=null;
        if(head!=null){
            head.prev=newnode;
        }
        head=newnode;
    }
    public void insertend(int val){
        Node newnode=new Node(val);
        Node curr=head;
        if(curr==null){
            insert(val);
        }
        else{
            while(curr.next!=null){
                curr=curr.next;
            }
            newnode.prev=curr;
            newnode.next=null;
            curr.next=newnode;
        }
    }
    public void insertpos(int pos,int val){
        Node newnode=new Node(val);
        Node curr=head;
        if(curr==null){
            insert(val);
        }
        else{
            for(int i=1;i<pos-1;i++){
                curr=curr.next;
            }
            newnode.prev=curr;
            curr=curr.next;
            newnode.next=curr;
            curr.prev=newnode;
        }
    }
    public void disp(){
        Node curr=head;
        while(curr!=null){
            System.out.println(curr.data);
            curr=curr.next;
        }
    }
    public void disprev(){
        Node curr=head;
        while(curr.next!=null){
            curr=curr.next;
        }
        while(curr!=null){
            System.out.println(curr.data);
            curr=curr.prev;
        }
    }
    public static void main(String[] args) {
        Doublelinklist dl=new Doublelinklist();
        for(int i=0;i<5;i++){
            dl.insert(i);
        }
        dl.insertend(9);
        dl.insertend(10);
        dl.insertend(11);
        dl.insertpos(5, 0);
        dl.disprev();
    }
}