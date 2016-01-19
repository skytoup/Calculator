package com.example.calculator;

import java.util.ArrayList;
import java.util.Iterator;
import android.widget.TextView;

public class Compute {
	private TextView tView1,tView2;
	private String[] view;
	private int state=0;
	private Boolean point=false;
	
	public Compute(TextView tView1,TextView tView2,String[] view){
		this.tView1=tView1;
		this.tView2=tView2;
		this.view=view;
	}
	
	public void stateDeal(String arg2){
		if(arg2.matches("[0-9]")){
			state=0;
		}else if(arg2.matches("[.]")){
			point=true;
			state=1;
		}else if(arg2.matches("[=]")){
			state=3;
		}else {
			point=false;
			state=2;
		}
	}
	
	public Float operation(String equation){
		String operator;
		String[] sub = null;
		Float result;
		ArrayList<Float> list=new ArrayList<Float>();
		
		if(equation.matches(".+[+].+")){
			operator="+";
			System.out.println("+");
			sub=equation.split("[+]");
		}else if(equation.matches(".+[-].+")){
			operator="-";
			System.out.println("+");
			sub=equation.split("[-]");
		}else if(equation.matches(".+[*].+")){
			operator="*";
			System.out.println("+");
			sub=equation.split("[*]");
		}else if(equation.matches(".+[/].+")){
			operator="/";
			System.out.println("+");
			sub=equation.split("[/]");
		}else {
			System.out.println(equation);
			return Float.parseFloat(equation.trim());
		}
		
		for(int i=0;i<sub.length;i++){
			list.add(operation(sub[i]+""));
		}
		
		Iterator<Float> iterator=list.iterator();
		if(operator=="+"){
			for(result=0f;iterator.hasNext();){
				result+=iterator.next();
			}
		}else if(operator=="-"){
			for(result=iterator.next();iterator.hasNext();){
				result-=iterator.next();
			}
		}else if(operator=="*"){
			for(result=iterator.next();iterator.hasNext();){
				result*=iterator.next();
			}
		}else{
			for(result=iterator.next();iterator.hasNext();){
				result/=iterator.next();
			}
		}	
		return result;
	}
	
	public void cli(int arg2){
		if(((tView1.getText().toString().length()==1&&tView1.getText().toString().matches("[0=]"))||state==3)&&view[arg2].matches("[/*+-.]")==false){
			if(state==3&&view[arg2]=="="){
				return;
			}
			tView1.setText(view[arg2]);
			point=false;
			stateDeal(view[arg2]);
			
		}else if(point&&view[arg2]=="."){
			
		}else if(state==0&&view[arg2].matches("[=]")){
			Float temp;
			temp=operation(tView1.getText().toString().trim()+"");
			tView2.setText(tView1.getText()+view[arg2]);
			tView1.setText(temp.toString());
			if(temp.toString().lastIndexOf(".")!=-1){
				point=true;
			}else {
				point=false;
			}
			stateDeal(view[arg2]);
			
		}else if(state==0||state==3){
			if(state==3&&view[arg2].matches("[/*+-.]")){
				return;
			}
			tView1.setText(tView1.getText()+view[arg2]);
			stateDeal(view[arg2]);
			
		}else if((state==2||state==1)&&view[arg2].matches("[0-9]")){
			tView1.setText(tView1.getText()+view[arg2]);
			stateDeal(view[arg2]);		
		}
		
	}
	
	public void del() {
		String str=tView1.getText().toString();
		if(str.length()==1){
			state=0;
			tView1.setText("0");
			return;
		}
		tView1.setText(str.substring(0, str.length()-1));
		if(str.lastIndexOf(".")==str.length()-1){
			point=false;
		}
		if(str.substring(str.length()-1, str.length()).matches("[/*+-]")){
			int index;
			String temp=tView1.getText().toString();
			if((index=temp.lastIndexOf("+"))!=-1){
				
			}else if((index=temp.lastIndexOf("-"))!=-1){
				
			}else if((index=temp.lastIndexOf("*"))!=-1){
				
			}else if((index=temp.lastIndexOf("/"))!=-1){
				
			}else {
				index=0;
			}
			if(temp.substring(index,temp.length()).indexOf(".")!=-1){
				point=true;
			}else{
				point=false;
			}
		}
		stateDeal(str.substring(str.length()-2, str.length()-1));
	}
	
	public void c(){
		tView1.setText("0");
		tView2.setText("");
		state=0;
		point=false;
	}
}
