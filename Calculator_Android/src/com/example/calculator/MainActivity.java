package com.example.calculator;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;

import net.youmi.android.AdManager;
import net.youmi.android.diy.banner.DiyAdSize;
import net.youmi.android.diy.banner.DiyBanner;
import net.youmi.android.offers.OffersManager;
import net.youmi.android.spot.SpotManager;
import android.app.Activity;
import android.os.Bundle;
import android.os.Handler;
import android.view.Gravity;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.AdapterView.OnItemSelectedListener;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.GridView;
import android.widget.SimpleAdapter;
import android.widget.TextView;

public class MainActivity extends Activity {
	private String[] view = new String[] {
	"7", "8", "9", "/", "4", "5", "6", "*", "1", "2", "3", "-", "0", ".", "=",
			"+", };
	private Compute compute;
	private GridView gridView;
	private Button button, button2;
	private TextView tView1, tView2;
	private Handler handler;
	Timer timer;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		AdManager.getInstance(this).init("b8d1742f93ff5bca",
				"604765a32396a7fc", true);
		OffersManager.getInstance(this).onAppLaunch();
		new Thread() {
			public void run() {
				while (true) {
					SpotManager.getInstance(MainActivity.this).loadSpotAds();
					SpotManager.getInstance(MainActivity.this).setSpotTimeout(
							5000);
					try {
						sleep(160000);
					} catch (InterruptedException e) {
						e.printStackTrace();
					}
				}
			};
		}.start();
		handler = new Handler() {
			public void handleMessage(android.os.Message msg) {
				if (msg.what == 123) {
					SpotManager.getInstance(MainActivity.this).showSpotAds(
							MainActivity.this);
				}
			};
		};
		
		FrameLayout.LayoutParams layoutParams = new FrameLayout.LayoutParams(
				FrameLayout.LayoutParams.FILL_PARENT,
				FrameLayout.LayoutParams.WRAP_CONTENT);
		layoutParams.gravity = Gravity.TOP | Gravity.LEFT;
		DiyBanner banner = new DiyBanner(this, DiyAdSize.SIZE_MATCH_SCREENx32);
		this.addContentView(banner, layoutParams);
		ArrayList<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		for (int i = 0; i < 16; i++) {
			HashMap<String, Object> hashMap = new HashMap<String, Object>();
			hashMap.put("text", view[i]);
			list.add(hashMap);
		}
		SimpleAdapter adapter = new SimpleAdapter(MainActivity.this, list,
				R.layout.bt, new String[] { "text" }, new int[] { R.id.bt1 });
		gridView = (GridView) this.findViewById(R.id.gridView1);
		gridView.setAdapter(adapter);
		tView1 = (TextView) this.findViewById(R.id.textView1);
		tView2 = (TextView) this.findViewById(R.id.textView2);
		button = (Button) this.findViewById(R.id.button1);
		button2 = (Button) this.findViewById(R.id.button2);
		compute = new Compute(tView1, tView2, view);
		button.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				compute.c();
			}
		});
		button2.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				compute.del();
			}
		});

		gridView.setOnItemClickListener(new OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int arg2,
					long arg3) {
				compute.cli(arg2);
			}
		});

		gridView.setOnItemSelectedListener(new OnItemSelectedListener() {
			@Override
			public void onItemSelected(AdapterView<?> arg0, View arg1,
					int arg2, long arg3) {
				compute.cli(arg2);
			}

			@Override
			public void onNothingSelected(AdapterView<?> arg0) {

			}
		});
	}

	@Override
	protected void onResume() {
		// TODO Auto-generated method stub
		super.onResume();
		timer = new Timer();
		timer.schedule(new TimerTask() {

			@Override
			public void run() {
				// TODO Auto-generated method stub
				handler.sendEmptyMessage(123);
			}
		}, 40000);
	}

	@Override
	protected void onPause() {
		// TODO Auto-generated method stub
		super.onPause();
		timer.cancel();
	}
}