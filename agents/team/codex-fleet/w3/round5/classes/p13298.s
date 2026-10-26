# n=5 model=out iset=I1 prefix14_class=13298
cmp P0, P3
cmovle S0, P0
cmovl P0, P3
cmovl P3, S0
cmp P2, P1
cmovle S1, P1
mov S2, P3
cmovle P1, P2
cmovl P2, S1
cmp S2, P1
cmovg P3, P1
cmovge P1, S2
mov P3, P0
cmp P0, P2
