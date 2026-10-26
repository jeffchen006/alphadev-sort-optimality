# n=5 model=out iset=I1 prefix14_class=1633
cmp P2, P3
mov S2, P1
cmovg S0, P2
cmovle S0, P3
cmovge P2, P3
cmp P0, P1
cmovl P1, P0
cmovg S2, P0
cmp P2, P1
mov P0, P2
cmovg P0, P1
cmovl P2, P1
mov P1, S0
cmp P1, S2
