package no.hvl.dat103;

public class Buffer {
	private int[] items;
	private int size, start, end, counter;
	
	public Buffer(int n) {
		size = n;
		start = 0;
		counter = 0;
		end = 0;
		items = new int[size];
	}
	
	public int insert(int i) {
		if (counter == size) {
			return -1;
		}
		
		items[end] = i;
		end = (end + 1) % size;
		counter++;
		return 0;
	}
	
	public int delete() {
		if (counter==0) {
			return -1;
		}
		int item = items[start];
		start = (start + 1) % size;
		counter--;
		return item;
	}
	
}
