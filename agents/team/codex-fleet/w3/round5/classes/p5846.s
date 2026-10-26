# n=5 model=out iset=I1 prefix14_class=5846
cmp P0, P2
cmovle S2, P0
cmovle P0, P2
cmovge S2, P2
cmp P1, P3
mov P2, P1
cmovl P1, P3
cmovge P2, P3
cmp P2, S2
cmovle P3, P2
cmovl P2, S2
mov S0, P0
cmovl S2, P3
cmp P0, P1
