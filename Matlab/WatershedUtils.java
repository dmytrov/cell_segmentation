import java.util.*;

class WatershedUtils
{
    public HashMap<Integer, HashMap<Integer, LinkedList<Double>>> stat;
    
    private int[] ToIntArray(java.lang.Integer[] x){
        int res[] = new int[x.length];
        for (int i = 0; i<x.length; i++){
            res[i] = x[i]; 
        }
        return res;
    }
    
    private double[] ToDoubleArray(java.lang.Double[] x){
        double res[] = new double[x.length];
        for (int i = 0; i<x.length; i++){
            res[i] = x[i]; 
        }
        return res;
    }
    
    public int[] GetClustersArray(){
        return ToIntArray(stat.keySet().toArray(new Integer[0]));
    }
    
    public int[] GetAdjacentClustersArray(int clusterID){
        return ToIntArray(stat.get(clusterID).keySet().toArray(new Integer[0]));
    }
    
    public double[] GetAdjacencyStatistics(int c1, int c2){
        return ToDoubleArray(stat.get(c1).get(c2).toArray(new Double[0]));
    }
    
    
    public WatershedUtils(){
        // Matlab requires it
        stat = new HashMap<Integer, HashMap<Integer, LinkedList<Double>>>();
    }

	public static void Invoke(){
        // Test
        System.out.println("Test message from WatershedUtils");
    }

    private void AddToStat(int w1, int w2, double imgVal){
        if (w1 < w2){
            int tmp = w1;
            w1 = w2;
            w2 = tmp;
        }
        
        HashMap<Integer, LinkedList<Double>> setForW1 = stat.get(w1);
        if (setForW1 == null){
            setForW1 = new HashMap<Integer, LinkedList<Double>>();
            stat.put(w1, setForW1);
        }
        
        LinkedList<Double> setForW2 = setForW1.get(w2);
        if (setForW2 == null){
            setForW2 = new LinkedList<Double>();
            setForW1.put(w2, setForW2);
        }
        setForW2.add(imgVal);
        
    }
    
    public void AddToAdjacencyStatistics(double[][][] img, int[][][] ws){
        int n1 = ws.length;
        int n2 = ws[0].length;
        int n3 = ws[0][0].length;
        
        int nClusters = 0;
        for (int k1 = 0; k1 < n1; k1++){
            for (int k2 = 0; k2 < n2; k2++){
                for (int k3 = 0; k3 < n3; k3++){
                    if (ws[k1][k2][k3] > nClusters)
                        nClusters = ws[k1][k2][k3];
                }
            }            
        }
        System.out.println("Number of clusters: " + nClusters);
        
        // HashMap<Integer, HashMap<Integer, LinkedList<Double>>> stat = new HashMap<Integer, HashMap<Integer, LinkedList<Double>>>();
        
        for (int k1 = 1; k1 < n1-1; k1++){
            for (int k2 = 1; k2 < n2-1; k2++){
                for (int k3 = 1; k3 < n3-1; k3++){
                    if (ws[k1][k2][k3] == 0){
                        int w1 = ws[k1+1][k2][k3];
                        int w2 = ws[k1-1][k2][k3];
                        if ((w1 != 0) && (w2 != 0) && (w1 != w2)){
                            AddToStat(w1, w2, img[k1][k2][k3]);
                        }
                        else
                        {
                            w1 = ws[k1][k2+1][k3];
                            w2 = ws[k1][k2-1][k3];
                            if ((w1 != 0) && (w2 != 0) && (w1 != w2)){
                                AddToStat(w1, w2, img[k1][k2][k3]);
                            }
                            else
                            {
                                w1 = ws[k1][k2][k3+1];
                                w2 = ws[k1][k2][k3-1];
                                if ((w1 != 0) && (w2 != 0) && (w1 != w2)){
                                    AddToStat(w1, w2, img[k1][k2][k3]);
                                }
                            }
                        }
                    }
                }
            }            
        }
        //System.out.println("stat.size: " + stat.size());
        
        //double[][] res = {{nClusters, stat.size(), 6, 7},
                          //{6, 4, 7, 8}};
        //return stat;
    }        
}