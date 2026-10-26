# n=5 model=out iset=I1 prefix14_class=3123
cmp P0, P3
cmovg S0, P3
cmovle S0, P0
cmovg P3, P0
mov S1, P2
cmp P1, P2
cmovg S1, P1
cmovle P2, P1
mov P0, S0
cmp S0, P2
cmovge P0, P2
mov P0, P3
cmovle S0, P2
cmp S1, P3
