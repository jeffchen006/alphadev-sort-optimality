# n=5 model=out iset=I1 prefix14_class=1913
mov S2, P3
cmp P2, S2
cmovl P3, P2
mov S1, P0
cmovle P2, S2
cmp P0, P1
cmovle S1, P1
cmovle P1, P0
cmp S1, P2
cmovl S0, S1
cmovge S0, P2
mov S2, P3
cmovle S1, P2
mov S1, S0
