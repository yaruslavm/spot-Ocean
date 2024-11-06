# Define the PDB name you're searching for
PDB_NAME="spot-admission"
 
# Find the namespace containing the PDB
NAMESPACE=$(kubectl get pdb --all-namespaces -o jsonpath="{.items[?(@.metadata.name=='$PDB_NAME')].metadata.namespace}")
 
# Check if the PDB was found
if [ -z "$NAMESPACE" ]; then
  echo "PDB '$PDB_NAME' not found in any namespace."
else
  echo "PDB '$PDB_NAME' found in namespace '$NAMESPACE'. Deleting..."
  
  # Delete the PDB
  kubectl delete pdb $PDB_NAME -n $NAMESPACE
 # Create new PDB in 
cat <<EOF | kubectl create -f - apiVersion: policy/v1 kind: PodDisruptionBudget metadata: namespace: kube-system name: spot-admission-controller-pdb spec: minAvailable: 1 selector: matchLabels: app.kubernetes.io/name: spot-admission-controller EOF

fi
