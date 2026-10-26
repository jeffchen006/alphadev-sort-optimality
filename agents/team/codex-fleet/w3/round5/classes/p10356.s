# n=5 model=out iset=I1 prefix14_class=10356
cmp P3, P2
cmovg S0, P3
cmovle S0, P2
cmovg P3, P2
cmp P1, P0
cmovg P2, P0
cmovg P0, P1
cmovg P1, P2
mov S1, P0
cmp S0, P0
cmovle P0, S0
cmovge S1, S0
cmp P3, P1
cmovle S0, P1
