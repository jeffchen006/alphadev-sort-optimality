# n=5 model=out iset=I1 prefix14_class=2224
cmp P3, P0
mov S1, P1
mov S0, P0
cmovge P0, P3
cmovg P3, S0
cmp P2, S1
cmovg P1, P2
mov S2, P1
cmovg P2, S1
cmp S2, P0
cmovle S2, P0
mov S2, P2
cmovle P0, P1
cmp P3, P2
