# n=5 model=out iset=I1 prefix14_class=10537
mov S2, P0
mov S1, P3
cmp P0, P2
cmovl P0, P2
cmovle P2, S2
cmp P1, P3
cmovg P3, P1
cmovge P1, S1
mov S0, P2
cmp P3, P0
cmovle S2, P0
cmovl P0, P3
cmovl P3, S2
mov P3, P0
