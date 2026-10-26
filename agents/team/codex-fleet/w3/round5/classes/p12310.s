# n=5 model=out iset=I1 prefix14_class=12310
cmp P1, P2
cmovg S0, P2
cmovle S0, P1
mov S1, P3
cmovle P1, P2
cmp P0, P3
cmovle P3, P0
cmovg S1, P0
cmp P3, S0
cmovge P2, P3
cmovg P3, S0
cmovge S0, P2
cmp S1, P1
mov P3, S1
