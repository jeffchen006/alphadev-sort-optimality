# n=5 model=out iset=I1 prefix14_class=3526
mov S2, P1
cmp S2, P2
cmovg P1, P2
cmovge P2, S2
mov S0, P3
cmp S0, P0
cmovle P3, P0
cmovle P0, S0
cmp P0, P1
mov S0, P1
cmovg P1, P0
cmovle S0, P0
cmp P3, P2
mov S0, P2
