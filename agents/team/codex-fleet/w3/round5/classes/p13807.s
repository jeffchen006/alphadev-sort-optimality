# n=5 model=out iset=I1 prefix14_class=13807
mov S2, P1
cmp S2, P2
cmovge S2, P2
mov S1, P0
cmovl P1, P2
cmp P0, P3
cmovle P0, P3
cmovg S1, P3
cmp P1, P0
cmovle S0, P0
cmovl P0, P1
cmovle P1, S0
cmp S1, S2
cmovg P2, S1
