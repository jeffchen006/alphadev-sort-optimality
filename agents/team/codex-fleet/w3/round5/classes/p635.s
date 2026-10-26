# n=5 model=out iset=I1 prefix14_class=635
mov S0, P1
mov S1, P2
cmp P2, P0
cmovle S1, P0
cmovge P2, P0
cmp S0, P3
cmovg P1, P3
cmovge P3, S0
cmp P3, S1
mov S0, P3
cmovle P3, S1
cmovle S1, S0
cmp P2, P1
mov S0, P1
