# n=5 model=out iset=I1 prefix14_class=12634
mov S2, P0
cmp S2, P1
cmovl P0, P1
mov S1, P3
cmovge S2, P1
cmp P2, P3
cmovle S1, P2
cmovl P2, P3
cmp S1, S2
cmovle P3, S2
cmovle S2, S1
cmovl S1, P3
mov S0, S1
cmp P0, P2
