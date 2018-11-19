package no.hvl.dat103;

public class Semafor {
	private int count;
	
	public Semafor(int n) {
		count = n;
	}
	
	public void acquire() {
		while (!ledig());
		
		synchronized (this) {
			count--;
		}
	}
	
	public void release() {
		synchronized (this) {
			count++;
		}
	}
	
	public synchronized boolean ledig() {
		return count > 0;
	}
}
