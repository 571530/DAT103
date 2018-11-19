package no.hvl.dat103;

import java.util.concurrent.Semaphore;

public class Philosopher extends Thread {
	private Semaphore[] chopsticks;
	private int id;

	public Philosopher(Semaphore[] chopsticks, int i) {
		super();
		this.chopsticks = chopsticks;
		id = i;
	}

	public void run() {
		do {
			if (id % 2 == 0) {
				try {
					chopsticks[id].acquire();
				} catch (InterruptedException e1) {
				}
				try {
					chopsticks[(id + 1) % chopsticks.length].acquire();
				} catch (InterruptedException e1) {
				}
			}
			else {
				try {
					chopsticks[(id + 1) % chopsticks.length].acquire();
				} catch (InterruptedException e1) {
				}
				try {
					chopsticks[id].acquire();
				} catch (InterruptedException e1) {
				}
			}

			System.out.println("Filosof nummer " + id + " spiser");

			try {
				Thread.sleep(500); // Spising
			} catch (InterruptedException e) {
			}

			if (id % 2 == 0) {
				chopsticks[id].release();
				chopsticks[(id + 1) % chopsticks.length].release();
			}
			else {
				chopsticks[(id + 1) % chopsticks.length].release();
				chopsticks[id].release();
			}
			
			try {
				Thread.sleep(500); // Tenking
			} catch (InterruptedException e) {
			}
		} while (true);
	}

}
