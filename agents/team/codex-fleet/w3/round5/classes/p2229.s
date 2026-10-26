# n=5 model=out iset=I1 prefix14_class=2229
mov S1, P2
cmp P0, P3
mov S0, P3
cmovg P3, P0
cmovg P0, S0
cmp P1, P2
cmovg S1, P1
cmovge P1, P2
mov S0, S1
cmp S0, P3
cmovle S1, P3
cmovle P3, S0
mov S1, P1
cmp P0, P1
