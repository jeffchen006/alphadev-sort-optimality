# n=5 model=out iset=I1 prefix14_class=12878
cmp P1, P2
cmovle S0, P2
cmovle P2, P1
cmovle P1, S0
cmp P3, P0
mov S1, P3
cmovl P3, P0
cmovle P0, S1
mov S1, P0
cmp P0, P2
cmovl P0, P2
cmovge S1, P2
mov S1, P0
mov P2, P1
