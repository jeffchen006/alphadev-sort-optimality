# n=5 model=out iset=I1 prefix14_class=7890
cmp P1, P3
mov S0, P1
cmovg S0, P3
cmovge P3, P1
mov P1, P0
cmp P1, P2
cmovle P0, P2
cmovg P1, P2
mov S2, P1
cmp P1, S0
cmovge S2, S0
cmovg S0, P1
cmp P0, P3
cmovge S2, P0
