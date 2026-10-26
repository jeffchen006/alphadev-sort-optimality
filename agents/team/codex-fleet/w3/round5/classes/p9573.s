# n=5 model=out iset=I1 prefix14_class=9573
cmp P1, P0
cmovle S0, P1
mov S1, P2
cmovle P1, P0
cmovl P0, S0
cmp P3, P2
cmovge S1, P3
cmovge P3, P2
mov P2, P1
cmp P2, S1
cmovg P1, S1
cmovl P2, S1
mov P2, P0
mov S2, P1
