if type kubectl > /dev/null; then
  source <(command kubectl completion zsh)
fi

#
# Kubernetes utils
#

autoload colors && colors

# First, wrap kubectl in a function that detects commands like 'apply' or 'delete' and
# prompts user to confirm. Used to limit the possibility of running a destructive command
# on a wrong cluster.
#
# Additionally, prints out current context for reference.
kubectl() {
  if [ $# -lt 2 ]; then
    # skip straight to kubectl when command is called without arguments
    # e.g. kubectl, kubectl apply, kubeclt config
    command kubectl "$@"
    return
  fi

  local cmdname=$1; shift

  if [ "$cmdname" = "apply" ] || [ "$cmdname" = "delete" ]; then
    echo "\n🤖  $fg_bold[green]CONTEXT:$reset_color $(command kubectl config current-context)"
    echo "\n🚨 $fg_bold[red] DANGER ZONE $reset_color🚨\n"

    echo -n "==> Are you sure? (y/n)? "
    read answer

    if [ "$answer" = "${answer#[Yy]}" ]; then
      echo "Aborting."
      return 1
    fi
  fi

  command kubectl "$cmdname" "$@"
}

# kube
#
# A set of shortcuts for frequently run commands:
#
#   kube ls   - list all pods
#   kube lsv  - list all services
#   kube lsj  - list all jobs
#   kube bash - attach to a pod (choose pod with fzf)
#
# ...and more.

# allow to choose pod name using fzf
kube__pod() {
  kubectl get pods -o json | jq -r '.items[] .metadata.name' | fzf
}

# list contexts
kube__c() {
  kubectl config get-contexts "$@"
}

# current context
kube__cc() {
  kubectl config current-context "$@"
}

# list pods
kube__ls() {
  kubectl get pods "$@"
}

# list services
kube__lsv() {
  kubectl get services "$@"
}

# list jobs
kube__lsj() {
  kubectl get jobs "$@"
}

# list cron jobs
kube__lsc() {
  kubectl get cronjobs "$@"
}

# attach to pod, run bash (select name with fzf)
kube__bash() {
  kubectl exec -it $(kube__pod) -- bash
}

# describe pod (select name with fzf)
kube__dpod() {
  kubectl describe pod $(kube__pod)
}

# show logs for pod (select name with fzf)
kube__log() {
  kubectl logs $(kube__pod) "$@"
}

# logs for app
kube__logapp() {
  local app_label=$1; shift
  kubectl logs -l app="$app_label" "$@"
}

kube() {
  if [ $# -eq 0 ]; then
    echo "Usage:\n"
    echo "    kube <cmd>"
    return 1
  fi

  local cmdname=$1; shift
  if type "kube__$cmdname" >/dev/null 2>&1; then
    "kube__$cmdname" "$@"
  else
    local all_cmds="$(print -l ${(ok)functions} | grep 'kube__' | sed 's/kube__/    /')"

    echo
    echo "Unknown command $cmdname"
    echo "Available commands:\n"
    echo "$all_cmds"
    echo
    return 1
  fi
}
