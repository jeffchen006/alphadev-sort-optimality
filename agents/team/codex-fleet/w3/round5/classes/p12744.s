# n=5 model=out iset=I1 prefix14_class=12744
mov S1, P0
cmp P3, P0
cmovg P0, P3
cmovle S1, P3
cmp P2, P1
mov S0, P2
cmovl P2, P1
cmovle P1, S0
cmp P1, S1
cmovge S2, S1
cmovge S1, P1
cmovge P1, S2
cmp P0, P2
mov P1, S1
