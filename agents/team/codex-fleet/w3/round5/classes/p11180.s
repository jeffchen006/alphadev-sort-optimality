# n=5 model=out iset=I1 prefix14_class=11180
cmp P3, P1
mov S1, P2
cmovge S2, P1
cmovg P1, P3
cmovge P3, S2
cmp P2, P0
cmovle P2, P0
cmovle P0, S1
cmp P1, P2
cmovge S2, P1
cmovg P1, P2
mov S1, P1
mov S0, P3
cmovg P2, S2
