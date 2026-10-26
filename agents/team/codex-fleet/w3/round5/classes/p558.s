# n=5 model=out iset=I1 prefix14_class=558
cmp P1, P3
mov S1, P1
cmovge P1, P3
cmovg P3, S1
cmp P2, P0
mov S0, P2
cmovg P2, P0
cmovle S0, P0
mov P0, P1
cmp P2, P1
cmovle P0, P2
cmovg P1, P2
mov P2, S0
cmp P3, S0
