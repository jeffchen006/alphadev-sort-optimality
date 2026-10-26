# n=5 model=out iset=I1 prefix14_class=6130
cmp P0, P1
cmovle S0, P0
cmovg S0, P1
cmovl P0, P1
mov P1, P3
cmp P2, P1
cmovg P3, P2
cmovge P2, P1
cmp P0, P3
cmovge P1, P0
cmovg P0, P3
mov S2, S0
cmovg P3, P1
cmp P2, S0
