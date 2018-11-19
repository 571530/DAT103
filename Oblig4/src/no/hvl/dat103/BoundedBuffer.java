package no.hvl.dat103;

import java.util.Random;
import java.util.concurrent.Semaphore;

public class BoundedBuffer {

	public static void main(String[] args) {
		final int n = 10;
		
		
		Semaphore mutex = new Semaphore(1);
		Semaphore empty = new Semaphore(n);
		Semaphore full = new Semaphore(0);

		Buffer buffer = new Buffer(n);
		
		
		Thread producer = new Thread(() -> {
			Random random = new Random();
			do {
				int i = random.nextInt(1000000);
				
				try {
					empty.acquire();
				} catch (Exception e) {}
				try {
					mutex.acquire();
				} catch (Exception e) {}
				
				buffer.insert(i);
				
				mutex.release();
				full.release();
				
				System.out.println("Produced " + i);
			} while (true);
		});

		Thread consumer = new Thread(() -> {
			do {
				int i;
				
				try {
					full.acquire();
				} catch (Exception e) {}
				try {
					mutex.acquire();
				} catch (Exception e) {}
					
				i = buffer.delete();
				
				mutex.release();
				empty.release();
				
				System.out.println("Consumed " + i);
			} while (true);
		});
		
		producer.start();
		consumer.start();
		
	}
}
