# MancerG1Linux

Faz o display do water cooler MANCER G1 funcionar no Linux. O programa oficial só existe para Windows, então escrevi este.

Ele manda a temperatura da CPU para o display, igual ao programa oficial.

## Instalar

```
./install.sh
```

Rode com seu usuário normal. Ele pede a senha quando precisa.

Precisa de Python 3 e systemd.

## Remover

```
./uninstall.sh
```

## Problemas

**O display não mostra nada**
Reinicie o PC e veja se o cabo USB do cooler está ligado na placa-mãe.

**O display mostra 0**
O Linux não está lendo a temperatura da CPU. Rode `sensors` e veja se aparece `k10temp` (AMD) ou `coretemp` (Intel).

**Quero ver o que está acontecendo**
Rode `journalctl --user -u mancer-g1 -f`.

Testado só no modelo com ID USB `aa88:8666`.  tenho quase certeza que é universal o ID baseado no estudo do driver oficial de windows.
