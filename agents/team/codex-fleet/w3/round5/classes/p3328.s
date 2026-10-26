# n=5 model=out iset=I1 prefix14_class=3328
mov S0, P2
cmp P1, P0
cmovg S2, P0
cmovle S2, P1
cmovg P0, P1
cmp P2, P3
cmovge P2, P3
cmovge P3, S0
mov P1, P2
cmp P2, S2
cmovg P2, S2
cmovl P1, S2
mov S2, P1
cmp P3, P0
