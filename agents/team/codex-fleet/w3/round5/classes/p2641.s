# n=5 model=out iset=I1 prefix14_class=2641
mov S0, P0
cmp P2, S0
cmovg P0, P2
mov S2, P1
cmovge P2, S0
mov S0, P0
cmp P3, S2
cmovle S2, P3
cmovg P1, P3
cmp P1, P0
cmovle P0, P1
cmovle P1, S0
cmp P2, S2
mov P1, S2
