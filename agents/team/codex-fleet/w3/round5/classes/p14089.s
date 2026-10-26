# n=5 model=out iset=I1 prefix14_class=14089
cmp P0, P2
mov S1, P0
cmovl P0, P2
cmovle P2, S1
mov S1, P3
cmp P1, P3
cmovg S1, P1
cmovle P3, P1
cmp P0, S1
cmovle P1, S1
cmovle S1, P0
cmovl P0, P1
cmp P2, P3
mov P0, P3
