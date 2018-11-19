package no.hvl.dat103;

import java.util.concurrent.Semaphore;

public class DiningPhilosophers {
	public static void main(String[] args) {
		final int NUM_PHILOSOPHERS = 5;
		
		Semaphore[] chopsticks = new Semaphore[NUM_PHILOSOPHERS];
		Philosopher[] philosophers = new Philosopher[NUM_PHILOSOPHERS];
		
		for (int i = 0; i < NUM_PHILOSOPHERS; i++) {
			chopsticks[i] = new Semaphore(1);
			philosophers[i] = new Philosopher(chopsticks, i);
		}
		
		for (Philosopher phil : philosophers) {
			phil.start();
		}
		
	}
}
