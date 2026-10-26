# n=5 model=out iset=I1 prefix14_class=9315
cmp P1, P3
mov S2, P1
cmovle P1, P3
cmovl P3, S2
cmp P0, P2
cmovge S1, P2
cmovle S1, P0
mov S0, S1
cmovl P0, P2
cmp P3, S1
cmovge S1, P3
cmovge P3, S0
cmp P0, P1
mov P3, P0
