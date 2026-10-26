# n=5 model=out iset=I1 prefix14_class=13890
mov S0, P2
cmp P2, P1
cmovg P2, P1
cmovg P1, S0
cmp P0, P3
cmovge S0, P3
cmovg P3, P0
cmovge P0, S0
cmp P3, P1
mov S1, P1
cmovge P1, P3
cmovge P3, S1
cmp P0, P2
mov P1, P0
