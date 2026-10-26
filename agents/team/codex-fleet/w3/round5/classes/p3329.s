# n=5 model=out iset=I1 prefix14_class=3329
cmp P1, P0
mov S0, P2
cmovg S2, P0
cmovle S2, P1
cmovge P0, P1
cmp P2, P3
cmovg P2, P3
cmovg P3, S0
mov P1, P2
cmp P2, S2
cmovge P2, S2
cmovl P1, S2
cmp P3, P0
cmovge S2, P1
