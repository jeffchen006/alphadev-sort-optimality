# n=5 model=out iset=I1 prefix14_class=10775
cmp P0, P2
cmovle S0, P0
cmovg S0, P2
cmovg P2, P0
cmp P3, P1
mov P0, P3
cmovle P3, P1
cmovl P1, P0
cmp P2, P3
cmovl S1, P2
cmovl P2, P3
cmovl P3, S1
cmp P1, S0
cmovge P0, S0
