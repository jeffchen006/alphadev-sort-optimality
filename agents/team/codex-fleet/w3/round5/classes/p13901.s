# n=5 model=out iset=I1 prefix14_class=13901
cmp P3, P0
cmovg S0, P0
cmovle S0, P3
mov S2, P1
cmovge P0, P3
cmp P2, S2
cmovge P1, P2
cmovge P2, S2
cmp P0, P1
cmovge S2, P1
cmovge P1, P0
cmovge P0, S2
cmp P2, S0
cmovl S2, P2
