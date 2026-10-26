# n=5 model=out iset=I1 prefix14_class=7913
cmp P1, P3
mov S2, P1
cmovl P1, P3
cmovle P3, S2
mov S2, P0
cmp P2, S2
cmovle S2, P2
cmovge P0, P2
cmp P3, S2
cmovge P2, S2
cmovg S2, P3
cmovle P2, P3
cmp P0, P1
cmovle P2, P0
