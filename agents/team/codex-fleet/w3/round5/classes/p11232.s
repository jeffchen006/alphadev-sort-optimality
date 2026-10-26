# n=5 model=out iset=I1 prefix14_class=11232
mov S1, P1
cmp P1, P3
cmovge P1, P3
cmovge P3, S1
cmp P2, P0
cmovle S0, P0
mov S1, P3
cmovl P0, P2
cmovle P2, S0
cmp P2, S1
cmovge P3, P2
cmovg P2, S1
cmovl S1, P2
cmp P1, P0
