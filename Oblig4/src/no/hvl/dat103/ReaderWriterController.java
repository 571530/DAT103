package no.hvl.dat103;

public class ReaderWriterController {
	private volatile int readCount = 0;

	private boolean writing = false;
	
	public boolean isWriting() {
		return writing;
	}

	public void setWriting(boolean writing) {
		this.writing = writing;
	}

	public synchronized void removeReader() {
		readCount--;
	}
	
	public synchronized void addReader() {
		readCount++;
	}
	
	public int getReadCount() {
		return readCount;
	}

	public void setReadCount(int read_count) {
		this.readCount = read_count;
	}
}
