# n=5 model=out iset=I1 prefix14_class=10428
cmp P2, P3
cmovle S1, P3
cmovg S1, P2
mov S0, P0
cmovl P3, P2
cmp P1, P0
cmovle P0, P1
cmovl P1, S0
cmp P1, S1
mov P2, P0
cmovle S2, P1
cmovl P1, S1
cmovl S1, S2
cmp P3, P2
