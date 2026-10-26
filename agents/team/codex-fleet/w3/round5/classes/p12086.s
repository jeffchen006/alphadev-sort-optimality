# n=5 model=out iset=I1 prefix14_class=12086
mov S0, P3
cmp P0, P1
mov S1, P0
cmovge P0, P1
cmovg P1, S1
cmp P2, P3
cmovg P3, P2
cmovg P2, S0
cmp P0, P2
cmovle S1, P2
cmovl P2, P0
mov P2, P3
cmovl P0, S1
cmp P1, P3
