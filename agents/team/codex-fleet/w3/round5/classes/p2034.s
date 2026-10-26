# n=5 model=out iset=I1 prefix14_class=2034
mov S2, P0
mov S0, P1
cmp P2, S0
cmovge P1, P2
cmovg P2, S0
cmp P3, S2
cmovge P0, P3
cmovle S2, P3
cmovl P3, P0
cmp P0, P1
cmovg P3, P1
cmovge P1, P0
mov P1, P2
cmovg P0, P3
