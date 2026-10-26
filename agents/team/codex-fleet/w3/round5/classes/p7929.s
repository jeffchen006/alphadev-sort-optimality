# n=5 model=out iset=I1 prefix14_class=7929
cmp P3, P0
mov S0, P2
mov S2, P3
cmovl S2, P0
cmovle P0, P3
cmp P2, P1
cmovge P2, P1
cmovge P1, S0
mov S0, P0
cmp P0, P2
cmovg S0, P2
cmovge P2, P0
cmp P1, S2
cmovge P0, S2
