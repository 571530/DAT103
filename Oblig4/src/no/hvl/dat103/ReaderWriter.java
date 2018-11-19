package no.hvl.dat103;

import java.util.Random;
import java.util.concurrent.Semaphore;

public class ReaderWriter {
	public static void main(String[] args) {
		final int NUM_READERS = 5;

		Random random = new Random();

		Semaphore mutex = new Semaphore(1);
		Semaphore rw_mutex = new Semaphore(1);
		ReaderWriterController controller = new ReaderWriterController();

		Thread writing_thread = new Thread(() -> {
			do {
				try {
					Thread.sleep(random.nextInt(500)); // Simulere klargjøring av data
				} catch (InterruptedException e) {
				}

				try {
					rw_mutex.acquire();
				} catch (Exception e) {
				}

				controller.setWriting(true);
				
				try {
					Thread.sleep(random.nextInt(500)); // Simulere skriving av data
				} catch (InterruptedException e) {
				}
				
				controller.setWriting(false);

				rw_mutex.release();

			} while (true);
		});

		Thread[] reading_threads = new Thread[NUM_READERS];
		for (int i = 0; i < NUM_READERS; i++) {
			reading_threads[i] = new Thread(() -> {
				do {
					try {
						mutex.acquire();
					} catch (Exception e1) {

					}
					controller.addReader();
					if (controller.getReadCount() == 1) {
						try {
							rw_mutex.acquire();
						} catch (Exception e) {
						}
					}
					mutex.release();
				
					try {
						Thread.sleep(random.nextInt(100)); // Simulere lesing av data
					} catch (InterruptedException e) {
					}

					try {
						mutex.acquire();
					} catch (Exception e1) {
					}
					
					controller.removeReader();
					if (controller.getReadCount() == 0) {
						rw_mutex.release();
					}
					mutex.release();

					try {
						Thread.sleep(random.nextInt(100)); // Simulere bruk av data
					} catch (InterruptedException e) {
					}

				} while (true);
			});
		}

		Thread print_thread = new Thread(() -> {
			do {
			if (controller.isWriting()) {
				System.out.println("Writing");
			}
			else {
				System.out.println(controller.getReadCount() + " currently reading");
			}
			
			try {
				Thread.sleep(random.nextInt(1000));
			} catch (InterruptedException e) {
			}
			} while (true);
		});
		
		for (Thread thread : reading_threads) {
			thread.start();
		}

		writing_thread.start();
		
		print_thread.start();
	}
}
