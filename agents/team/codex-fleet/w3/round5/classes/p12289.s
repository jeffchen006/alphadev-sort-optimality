# n=5 model=out iset=I1 prefix14_class=12289
mov S0, P2
cmp P1, S0
cmovl P2, P1
mov S2, P2
cmovge S0, P1
cmp P0, P3
cmovge P1, P3
cmovge P3, P0
cmovge P0, P1
cmp P2, P0
cmovge S2, P0
cmovg P0, P2
cmp P3, S0
cmovle P1, P3
