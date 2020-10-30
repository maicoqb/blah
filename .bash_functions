fn_idea() {
  if [[ -z "$1" ]]; then
    echo "Iniciando o IntelliJ global"
    /opt/IntelliJ/current/bin/idea.sh >> /dev/null 2>&1 &
    return 0;
  fi

  INTELLIJ_CURRENT_DIR=$(realpath $1)
  echo "Iniciando o IntelliJ $INTELLIJ_CURRENT_DIR"
  /opt/IntelliJ/current/bin/idea.sh "$INTELLIJ_CURRENT_DIR" >> /dev/null 2>&1 &
}

fn_datagrip() {
  /opt/DataGrip/current/bin/datagrip.sh >> /dev/null 2>&1 &
}

fn_forget() {
  history -d $(history 1)
  history -d $(history 1)
}

